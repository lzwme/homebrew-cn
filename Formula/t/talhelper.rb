class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://ghfast.top/https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.1.3.tar.gz"
  sha256 "f47f78e1877c74d858d342cb4e138864b239db2f0b2cb61f4f5548482f1e8bec"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddf61d801433df1bc7197047a81ad49f4fd1ea84db8c2fc872771817b73bf145"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddf61d801433df1bc7197047a81ad49f4fd1ea84db8c2fc872771817b73bf145"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddf61d801433df1bc7197047a81ad49f4fd1ea84db8c2fc872771817b73bf145"
    sha256 cellar: :any_skip_relocation, sonoma:        "9211e17c13eb474102f945ab9e57300d2718d96fd31041eae2dbbe419474aae2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63e97e87cbf92840832077ba4e5898c425dba5013372ecd7234555557201c1be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8a26fb819b7fb5d2ee1b62864e317432e9fe135c1a40201d97ec30ee342fcf6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/v#{version.major}/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"talhelper", shell_parameter_format: :cobra)
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