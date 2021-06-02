library(redCohort)

# Maximum number of cores to be used:
maxCores <- parallel::detectCores() 

# The folder where the study intermediate and result files will be written:
outputFolder <- "c:/redCohort"

# Details for connecting to the server:
connectionDetails <-
        DatabaseConnector::createConnectionDetails(
                dbms = "sql server",
                server = "127.0.0.1",
                user = "sa",
                password = "password1!",
                port = "1433",
                pathToDriver="C:/Program Files/sqljdbc_9.2.1.0_kor/sqljdbc_9.2/kor"
                )

# The name of the database schema where the CDM data can be found:
cdmDatabaseSchema <- "REDCDM_149work.dbo"

# The name of the database schema and table where the study-specific cohorts will be instantiated:
cohortDatabaseSchema <- "scratch.dbo"
cohortTable <- "rao_skeleton"

# Some meta-information that will be used by the export function:
databaseId <- "Synpuf"
databaseName <-
        "Medicare Claims Synthetic Public Use Files (SynPUFs)"
databaseDescription <-
        "Medicare Claims Synthetic Public Use Files (SynPUFs) were created to allow interested parties to gain familiarity using Medicare claims data while protecting beneficiary privacy. These files are intended to promote development of software and applications that utilize files in this format, train researchers on the use and complexities of Centers for Medicare and Medicaid Services (CMS) claims, and support safe data mining innovations. The SynPUFs were created by combining randomized information from multiple unique beneficiaries and changing variable values. This randomization and combining of beneficiary information ensures privacy of health information."

# For Oracle: define a schema that can be used to emulate temp tables:
#tempEmulationSchema <- NULL

redCohort::execute(
        connectionDetails = connectionDetails,
        cdmDatabaseSchema = cdmDatabaseSchema,
        cohortDatabaseSchema = cohortDatabaseSchema,
        cohortTable = cohortTable,
        tempEmulationSchema = tempEmulationSchema,
        outputFolder = outputFolder,
        databaseId = databaseId,
        databaseName = databaseName,
        databaseDescription = databaseDescription
)

CohortDiagnostics::preMergeDiagnosticsFiles(dataFolder = outputFolder)

CohortDiagnostics::launchDiagnosticsExplorer(dataFolder = outputFolder)


# Upload the results to the OHDSI SFTP server:
privateKeyFileName <- ""
userName <- ""
redCohort::uploadResults(outputFolder, privateKeyFileName, userName)
