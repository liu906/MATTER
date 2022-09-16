@if "%DEBUG%" == "" @echo off
@rem ##########################################################################
@rem
@rem  CrossPare startup script for Windows
@rem
@rem ##########################################################################

@rem Set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" setlocal

set DIRNAME=%~dp0
if "%DIRNAME%" == "" set DIRNAME=.
set APP_BASE_NAME=%~n0
set APP_HOME=%DIRNAME%..

@rem Add default JVM options here. You can also use JAVA_OPTS and CROSS_PARE_OPTS to pass JVM options to this script.
set DEFAULT_JVM_OPTS=

@rem Find java.exe
if defined JAVA_HOME goto findJavaFromJavaHome

set JAVA_EXE=java.exe
%JAVA_EXE% -version >NUL 2>&1
if "%ERRORLEVEL%" == "0" goto init

echo.
echo ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.
echo.
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation.

goto fail

:findJavaFromJavaHome
set JAVA_HOME=%JAVA_HOME:"=%
set JAVA_EXE=%JAVA_HOME%/bin/java.exe

if exist "%JAVA_EXE%" goto init

echo.
echo ERROR: JAVA_HOME is set to an invalid directory: %JAVA_HOME%
echo.
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation.

goto fail

:init
@rem Get command-line arguments, handling Windows variants

if not "%OS%" == "Windows_NT" goto win9xME_args

:win9xME_args
@rem Slurp the command line arguments.
set CMD_LINE_ARGS=
set _SKIP=2

:win9xME_args_slurp
if "x%~1" == "x" goto execute

set CMD_LINE_ARGS=%*

:execute
@rem Setup the command line

set CLASSPATH=%APP_HOME%\lib\crosspare.jar-0.1.0.jar;%APP_HOME%\lib\javagd-0.6.1.jar;%APP_HOME%\lib\JRI.jar;%APP_HOME%\lib\JRIEngine.jar;%APP_HOME%\lib\kxml2-min-2.3.0.jar;%APP_HOME%\lib\pdm-RPlugin-ce-TRUNK-SNAPSHOT.jar;%APP_HOME%\lib\REngine-0.6-8.1.jar;%APP_HOME%\lib\rengine-weka-inject-classes.jar;%APP_HOME%\lib\xmlpull-1.1.3.1.jar;%APP_HOME%\lib\xpp3_min-1.1.4c.jar;%APP_HOME%\lib\xstream-1.4.2.jar;%APP_HOME%\lib\log4j-1.2-api-2.5.jar;%APP_HOME%\lib\log4j-core-2.5.jar;%APP_HOME%\lib\log4j-iostreams-2.5.jar;%APP_HOME%\lib\weka-stable-3.8.3.jar;%APP_HOME%\lib\alternatingDecisionTrees-1.0.5.jar;%APP_HOME%\lib\probabilisticSignificanceAE-1.0.2.jar;%APP_HOME%\lib\RBFNetwork-1.0.8.jar;%APP_HOME%\lib\jmetal-exec-5.0.jar;%APP_HOME%\lib\jmetal-algorithm-5.0.jar;%APP_HOME%\lib\jmetal-problem-5.0.jar;%APP_HOME%\lib\jmetal-core-5.0.jar;%APP_HOME%\lib\commons-math3-3.5.jar;%APP_HOME%\lib\commons-io-2.4.jar;%APP_HOME%\lib\commons-lang3-3.4.jar;%APP_HOME%\lib\jgap-3.4.4.jar;%APP_HOME%\lib\jcgrid-0.05.jar;%APP_HOME%\lib\commons-cli-1.0.jar;%APP_HOME%\lib\commons-lang-2.6.jar;%APP_HOME%\lib\commons-collections4-4.0.jar;%APP_HOME%\lib\guava-19.0.jar;%APP_HOME%\lib\ojalgo-37.1.1.jar;%APP_HOME%\lib\mysql-connector-java-5.1.38.jar;%APP_HOME%\lib\elki-0.7.5.jar;%APP_HOME%\lib\json-20160810.jar;%APP_HOME%\lib\log4j-api-2.5.jar;%APP_HOME%\lib\java-cup-11b-2015.03.26.jar;%APP_HOME%\lib\java-cup-11b-runtime-2015.03.26.jar;%APP_HOME%\lib\weka-dev-3.9.5.jar;%APP_HOME%\lib\bounce-0.18.jar;%APP_HOME%\lib\mtj-1.0.4.jar;%APP_HOME%\lib\all-1.1.2.pom;%APP_HOME%\lib\netlib-java-1.1.jar;%APP_HOME%\lib\netlib-native_ref-osx-x86_64-1.1-natives.jar;%APP_HOME%\lib\netlib-native_ref-linux-x86_64-1.1-natives.jar;%APP_HOME%\lib\netlib-native_ref-linux-i686-1.1-natives.jar;%APP_HOME%\lib\netlib-native_ref-win-x86_64-1.1-natives.jar;%APP_HOME%\lib\netlib-native_ref-win-i686-1.1-natives.jar;%APP_HOME%\lib\netlib-native_ref-linux-armhf-1.1-natives.jar;%APP_HOME%\lib\native_ref-java-1.1.jar;%APP_HOME%\lib\netlib-native_system-osx-x86_64-1.1-natives.jar;%APP_HOME%\lib\netlib-native_system-linux-x86_64-1.1-natives.jar;%APP_HOME%\lib\netlib-native_system-linux-i686-1.1-natives.jar;%APP_HOME%\lib\netlib-native_system-linux-armhf-1.1-natives.jar;%APP_HOME%\lib\netlib-native_system-win-x86_64-1.1-natives.jar;%APP_HOME%\lib\netlib-native_system-win-i686-1.1-natives.jar;%APP_HOME%\lib\native_system-java-1.1.jar;%APP_HOME%\lib\core-1.1.2.jar;%APP_HOME%\lib\arpack_combined_all-0.1.jar;%APP_HOME%\lib\maven-reporting-api-3.0.jar;%APP_HOME%\lib\hamcrest-all-1.3.jar;%APP_HOME%\lib\elki-data-generator-0.7.5.jar;%APP_HOME%\lib\elki-clustering-0.7.5.jar;%APP_HOME%\lib\elki-itemsets-0.7.5.jar;%APP_HOME%\lib\elki-classification-0.7.5.jar;%APP_HOME%\lib\elki-timeseries-0.7.5.jar;%APP_HOME%\lib\elki-index-rtree-0.7.5.jar;%APP_HOME%\lib\elki-index-mtree-0.7.5.jar;%APP_HOME%\lib\elki-index-lsh-0.7.5.jar;%APP_HOME%\lib\elki-index-various-0.7.5.jar;%APP_HOME%\lib\elki-precomputed-0.7.5.jar;%APP_HOME%\lib\elki-geo-0.7.5.jar;%APP_HOME%\lib\elki-core-dbids-int-0.7.5.jar;%APP_HOME%\lib\log4j-1.2.9.jar;%APP_HOME%\lib\commons-codec-1.3.jar;%APP_HOME%\lib\trove4j-2.0.2.jar;%APP_HOME%\lib\xpp3-1.1.3.4.O.jar;%APP_HOME%\lib\TableLayout-20050920.jar;%APP_HOME%\lib\junit-addons-1.4.jar;%APP_HOME%\lib\java-cup-11b-20160615.jar;%APP_HOME%\lib\java-cup-runtime-11b-20160615.jar;%APP_HOME%\lib\jfilechooser-bookmarks-0.1.6.jar;%APP_HOME%\lib\jaxb-runtime-2.3.3.jar;%APP_HOME%\lib\istack-commons-runtime-3.0.11.jar;%APP_HOME%\lib\jakarta.xml.bind-api-2.3.3.jar;%APP_HOME%\lib\jakarta.activation-api-1.2.2.jar;%APP_HOME%\lib\doxia-sink-api-1.0.jar;%APP_HOME%\lib\elki-outlier-0.7.5.jar;%APP_HOME%\lib\elki-core-0.7.5.jar;%APP_HOME%\lib\elki-index-0.7.5.jar;%APP_HOME%\lib\elki-index-preprocessed-0.7.5.jar;%APP_HOME%\lib\elki-persistent-0.7.5.jar;%APP_HOME%\lib\elki-core-parallel-0.7.5.jar;%APP_HOME%\lib\elki-database-0.7.5.jar;%APP_HOME%\lib\elki-input-0.7.5.jar;%APP_HOME%\lib\elki-core-distance-0.7.5.jar;%APP_HOME%\lib\elki-core-math-0.7.5.jar;%APP_HOME%\lib\elki-core-data-0.7.5.jar;%APP_HOME%\lib\elki-core-api-0.7.5.jar;%APP_HOME%\lib\elki-core-dbids-0.7.5.jar;%APP_HOME%\lib\xstream-1.2.2.jar;%APP_HOME%\lib\commons-logging-1.0.jar;%APP_HOME%\lib\junit-3.8.1.jar;%APP_HOME%\lib\jclipboardhelper-0.1.0.jar;%APP_HOME%\lib\txw2-2.3.3.jar;%APP_HOME%\lib\jakarta.activation-1.2.2.jar;%APP_HOME%\lib\elki-core-util-0.7.5.jar;%APP_HOME%\lib\xpp3_min-1.1.3.4.O.jar;%APP_HOME%\lib\elki-logging-0.7.5.jar;%APP_HOME%\lib\jafama-2.3.2.jar;%APP_HOME%\lib\fastutil-8.4.4.jar;%APP_HOME%\lib\jniloader-1.1.jar

@rem Execute CrossPare
"%JAVA_EXE%" %DEFAULT_JVM_OPTS% %JAVA_OPTS% %CROSS_PARE_OPTS%  -classpath "%CLASSPATH%" de.ugoe.cs.cpdp.Runner %CMD_LINE_ARGS%

:end
@rem End local scope for the variables with windows NT shell
if "%ERRORLEVEL%"=="0" goto mainEnd

:fail
rem Set variable CROSS_PARE_EXIT_CONSOLE if you need the _script_ return code instead of
rem the _cmd.exe /c_ return code!
if  not "" == "%CROSS_PARE_EXIT_CONSOLE%" exit 1
exit /b 1

:mainEnd
if "%OS%"=="Windows_NT" endlocal

:omega
