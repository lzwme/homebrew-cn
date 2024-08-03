class Ec2AmiTools < Formula
  desc "Amazon EC2 AMI Tools (helps bundle Amazon Machine Images)"
  homepage "https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/set-up-ami-tools.html"
  url "https://ec2-downloads.s3.amazonaws.com/ec2-ami-tools-1.5.19.zip"
  sha256 "bdda4494bea7d55dfff995459dd4705a953f3365bbc69f03430c796b5cc1dd7f"

  livecheck do
    url "https://ec2-downloads.s3.amazonaws.com/"
    regex(/>ec2-ami-tools[._-]v?(\d+(?:\.\d+)+)\.zip</i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "760890f1ed79a9c2456cf6ab781414b976ad9ad71946b0adc6f8cd7a7dd126a3"
  end

  depends_on "openjdk"

  uses_from_macos "ruby"

  def install
    env = { JAVA_HOME: Formula["openjdk"].opt_prefix, EC2_AMITOOL_HOME: libexec }
    rm Dir["bin/*.cmd"] # Remove Windows versions
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
      Before you can use these tools you must export some variables to your $SHELL.
        export AWS_ACCESS_KEY="<Your AWS Access ID>"
        export AWS_SECRET_KEY="<Your AWS Secret Key>"
        export AWS_CREDENTIAL_FILE="<Path to the credentials file>"
    EOS
  end

  test do
    assert_match version.to_s, shell_output(bin/"ec2-ami-tools-version")
  end
end