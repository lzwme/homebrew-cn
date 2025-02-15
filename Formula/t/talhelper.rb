class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:budimanjojo.github.iotalhelperlatest"
  url "https:github.combudimanjojotalhelperarchiverefstagsv3.0.19.tar.gz"
  sha256 "96aa3aa2a591e698060481527f4b4006cb71eb9425fc88e75a3a55ae7e40edf9"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa73d2b93a4055d5943943b1fddbf3706635b8d53a1cb39d468085287a4bd4b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa73d2b93a4055d5943943b1fddbf3706635b8d53a1cb39d468085287a4bd4b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa73d2b93a4055d5943943b1fddbf3706635b8d53a1cb39d468085287a4bd4b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e183871eaaa9d17cf4ce094cf312e88e586f369082154913324dbbcf228f1d2"
    sha256 cellar: :any_skip_relocation, ventura:       "8e183871eaaa9d17cf4ce094cf312e88e586f369082154913324dbbcf228f1d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "255b474aaea6498ca78c9066775d9bf377bcde555390a23eba2b8b359445b491"
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