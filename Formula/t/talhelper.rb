class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://ghfast.top/https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.0.42.tar.gz"
  sha256 "9331a65c38e520f3d2bf80f50bc4d64349389ad822ee156ea5305d7cc5b1c646"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f57d41b0f8497a82f523739a4bf3d3c154e90fb899acf7c215cc290caf6547d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f57d41b0f8497a82f523739a4bf3d3c154e90fb899acf7c215cc290caf6547d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f57d41b0f8497a82f523739a4bf3d3c154e90fb899acf7c215cc290caf6547d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "01c9c4ff32db75948bd0a81d94331761724329ad8f5f2844d5bf32771f0183e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b4d63362b0a166e3cae22b4504f2097e9e1333c7479585048a63e50ddd2c2ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac131c17f5c9cdadad6c41f00a9b4745f6fdcd1f286613705f8341d6a8eda726"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/v#{version.major}/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}/example/*"], testpath

    output = shell_output("#{bin}/talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}/talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}/talhelper --version")
  end
end