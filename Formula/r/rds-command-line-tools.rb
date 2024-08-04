class RdsCommandLineTools < Formula
  desc "Amazon RDS command-line toolkit"
  homepage "https://web.archive.org/web/20161118122854/https://aws.amazon.com/developertools/2928"
  url "https://rds-downloads.s3.amazonaws.com/RDSCli-1.19.004.zip"
  sha256 "298c15ccd04bd91f1be457645d233455364992e7dd27e09c48230fbc20b5950c"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "4407dfd6ae745950a92bd1d2e7b2bbb9b00d96af8a36ecd98dc9c02029477ab6"
  end

  # Deprecated and replaced by AWS CLI for RDS
  # Ref: https://web.archive.org/web/20161119170150/http://docs.aws.amazon.com/AmazonRDS/latest/CommandLineReference/StartCLI.html
  deprecate! date: "2024-08-02", because: :deprecated_upstream

  depends_on "openjdk"

  def install
    env = { JAVA_HOME: Formula["openjdk"].opt_prefix, AWS_RDS_HOME: libexec }
    rm Dir["bin/*.cmd"] # Remove Windows versions
    etc.install "credential-file-path.template"
    libexec.install Dir["*"]
    Pathname.glob("#{libexec}/bin/*") do |file|
      next if file.directory?

      basename = file.basename
      next if basename.to_s == "service"

      (bin/basename).write_env_script file, env
    end
  end

  def caveats
    <<~EOS
      Before you can use these tools you must export a variable to your $SHELL.
        export AWS_CREDENTIAL_FILE="<Path to the credentials file>"

      To check that your setup works properly, run the following command:
        rds-describe-db-instances --headers
      You should see a header line. If you have database instances already configured,
      you will see a description line for each database instance.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rds-version")
  end
end