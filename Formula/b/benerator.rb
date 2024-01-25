class Benerator < Formula
  desc "Tool for realistic test data generation"
  homepage "https:rapiddweller.github.iohomebrew-benerator"
  url "https:github.comrapiddwellerrapiddweller-benerator-cereleasesdownload3.2.0rapiddweller-benerator-ce-3.2.0-jdk-11-dist.tar.gz"
  sha256 "dadc11c8f05efc30c51fd12d87d6d67a960f1ce1f03a1453c65873e1642ccae4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2a29d39f500d665eb68d076bcb8941a3537245a4ca391d55821b947b0f86247b"
  end

  depends_on "openjdk"

  def install
    # Remove unnecessary files
    rm_f Dir["bin*.bat", "binpom.xml"]

    # Installs only the "bin" and "lib" directories from the tarball
    libexec.install Dir["bin", "lib"]
    # Generate a script that sets the necessary environment variables
    env = Language::Java.overridable_java_home_env
    env["BENERATOR_HOME"] = libexec
    (bin"benerator").write_env_script(libexec"binbenerator", env)
  end

  test do
    # Test if version is correct
    assert_match "Benerator Community Edition #{version}-jdk-11",
                 shell_output("#{bin}benerator --version")
    assert_match "Java version:  #{Formula["openjdk"].version}", shell_output("#{bin}benerator --version")
    # Test if data is generated follow the corrected scheme.
    # We feed benerator an xml and a scheme in demodbscripth2.multischema.sql.
    # The XML scheme in myscript.xml have an inhouse test in <evaluate > to check if the data is generated correctly,
    # If no, benerator will throw an error, otherwise a success message will be printed.
    (testpath"myscript.xml").write <<~XML
      <setup defaultDataset="US" defaultLocale="en_US">
      <import domains="person,net,product">
      <import platforms="db">

      <comment>setting default values<comment>
      <setting name="stage" default="development">
      <setting name="database" default="h2">
      <setting name="dbUrl" default="jdbc:h2:mem:benerator">
      <setting name="dbDriver" default="org.h2.Driver">
      <setting name="dbSchema" default="public">
      <setting name="dbUser" default="sa">

      <comment>log the settings to the console<comment>
      <echo>{ftl:encoding:${context.defaultEncoding} default pageSize:${context.defaultPageSize}}<echo>
      <echo>{ftl:JDBC URL: ${dbUrl}}<echo>

      <comment>define a database that will be referred by the id 'db' subsequently<comment>
      <database id="db"
      url="{dbUrl}"
      driver="{dbDriver}"
      schema="{dbSchema}"
      user="{dbUser}"
      >

      <execute type="sql" target="db" uri="demodbscripth2.multischema.sql">

      <database id="schema1" url="{dbUrl}" driver="{dbDriver}" schema="schema1"
      user="{dbUser}">
      <database id="schema3" url="{dbUrl}" driver="{dbDriver}" schema="schema3"
      user="{dbUser}">

      <generate type="db_manufacturer" count="100" consumer="schema3">
      <id name="id" generator="IncrementGenerator">
      <attribute name="name" pattern="[A-Z][A-Z]{5,12}">
      <generate>
      <generate type="db_Category" count="10" consumer="schema1">
      <id name="id" generator="IncrementGenerator">
      <generate>
      <generate type="db_product" count="100" consumer="schema1">
      <id name="ean_code" generator="EANGenerator">
      <attribute name="price" pattern="[1-9]{1,2}">
      <attribute name="name" pattern="[A-Z][A-Z]{5,12}">
      <attribute name="notes" pattern="[A-Z][\n][a-z][0-9]{1,256}">
      <attribute name="description" pattern="[A-Z][\n][a-z][0-9]{1,256}">
      <reference name="manufacturer_id" source="schema3" targetType="db_manufacturer">
      <generate>

      <echo>Printing all generated data<echo>
      <iterate name="CAT_TRANS" type="db_Category" source="schema1" consumer="ConsoleExporter">
      <iterate name="PROD_TRANS" type="db_product" source="schema1" consumer="ConsoleExporter">
      <iterate name="MAN_TRANS" type="db_manufacturer" source="schema3" consumer="ConsoleExporter">

      <echo>Verifying generated data<echo>
      <evaluate assert="result == 10" target="schema1">select count(*) from "schema1"."db_Category"<evaluate>
      <evaluate assert="result == 100" target="schema1">select count(*) from "schema1"."db_product"<evaluate>
      <evaluate assert="result == 100" target="schema3">select count(*) from "schema3"."db_manufacturer"<evaluate>
      <echo>No Error Occurs. Data Generated Correctly<echo>
      <setup>
    XML

    assert_match "No Error Occurs. Data Generated Correctly",
      shell_output("#{bin}benerator myscript.xml")
  end
end