class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:budimanjojo.github.iotalhelperlatest"
  url "https:github.combudimanjojotalhelperarchiverefstagsv3.0.13.tar.gz"
  sha256 "d2913a71db63b94ec46e6f1237c2160b642003a2010752b2687ac65725c5799a"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9132dd710916f6f7ebf871ce4bd73dbf67ecf44ed84210a17614af45c4b4b4b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9132dd710916f6f7ebf871ce4bd73dbf67ecf44ed84210a17614af45c4b4b4b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9132dd710916f6f7ebf871ce4bd73dbf67ecf44ed84210a17614af45c4b4b4b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a237760c0e08bd7afd42c1c391ffbd77050f8fbf06b8ccaa24ab773423e1a2e"
    sha256 cellar: :any_skip_relocation, ventura:       "5a237760c0e08bd7afd42c1c391ffbd77050f8fbf06b8ccaa24ab773423e1a2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "459808055fe0dba68fdd1622bbdfd1308e9db0258bd6327d38d9a54e7052215d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.combudimanjojotalhelperv#{version.major}cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}example*"], testpath

    output = shell_output("#{bin}talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}talhelper --version")
  end
end