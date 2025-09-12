class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.300",
      revision: "a281d97ae5d6a00721bfaa293dd1a843d5616338"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6710d44cd58b3cda35d130d492655019b23b2617a7912e7bb9844bc6966fb46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6710d44cd58b3cda35d130d492655019b23b2617a7912e7bb9844bc6966fb46"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6710d44cd58b3cda35d130d492655019b23b2617a7912e7bb9844bc6966fb46"
    sha256 cellar: :any_skip_relocation, sonoma:        "d86a32412e0cfee10555e87f57425d9940a2f9949e393db5995f237f7b21d802"
    sha256 cellar: :any_skip_relocation, ventura:       "d86a32412e0cfee10555e87f57425d9940a2f9949e393db5995f237f7b21d802"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03db7afe372fe0fccf3f96af069e6c864d230f2ff886461d9f203db3b97f08b8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/v#{version.major}/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags:), "main/main.go"
  end

  test do
    version_out = shell_output("#{bin}/aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}/aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}/aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end