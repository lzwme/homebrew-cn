class KafkactlAwsPlugin < Formula
  desc "AWS Plugin for kafkactl"
  homepage "https://deviceinsight.github.io/kafkactl/"
  url "https://ghfast.top/https://github.com/deviceinsight/kafkactl-plugins/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "9fcab4135e68ffba6af40db21ab4c36f798a502be402f6c2d6557d316084b445"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a853dba2c902a4e1d8ad91d315c87cb95f3f37f58c9699e59890a46442b285b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a853dba2c902a4e1d8ad91d315c87cb95f3f37f58c9699e59890a46442b285b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a853dba2c902a4e1d8ad91d315c87cb95f3f37f58c9699e59890a46442b285b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8bd50ecbe9bc6140fdd5d2eeb0fbabc889958565b16785f4e22f28784d3d49b"
    sha256 cellar: :any_skip_relocation, ventura:       "b8bd50ecbe9bc6140fdd5d2eeb0fbabc889958565b16785f4e22f28784d3d49b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a3e72893fc1633d75bb8ef3643138d095697bb52664d4972a639248fbd90d66"
  end

  depends_on "go" => :build
  depends_on "kafkactl"

  def install
    Dir.chdir("aws") do
      ldflags = %W[
        -s -w
        -X main.Version=v#{version}
        -X main.GitCommit=#{tap.user}
        -X main.BuildTime=#{time.iso8601}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kafkactl-aws-plugin 2>&1", 1)
    config_file = testpath/".kafkactl.yml"
    config_file.write <<~YAML
      contexts:
          default:
              brokers:
                  - unknown-cluster.kafka.eu-west-1.amazonaws.com:9098
              sasl:
                  enabled: true
                  mechanism: oauth
                  tokenprovider:
                      plugin: aws
              tls:
                  enabled: true
    YAML

    ENV["KAFKA_CTL_PLUGIN_PATHS"] = bin

    kafkactl = Formula["kafkactl"].bin/"kafkactl"
    output = shell_output("#{kafkactl} -C #{config_file} get topics -V 2>&1", 1)
    assert_match "kafkactl-aws-plugin: plugin initialized", output
  end
end