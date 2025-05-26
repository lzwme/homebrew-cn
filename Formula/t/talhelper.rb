class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:budimanjojo.github.iotalhelperlatest"
  url "https:github.combudimanjojotalhelperarchiverefstagsv3.0.26.tar.gz"
  sha256 "b3f11dfd891f2cd1938567ebda17c45ce63d34eb7caab53f95b81ab2e664d188"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0d185d8414af0f31363ca5bb960b427b75209d420fb1fb05ff3f6525e1b9bc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0d185d8414af0f31363ca5bb960b427b75209d420fb1fb05ff3f6525e1b9bc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0d185d8414af0f31363ca5bb960b427b75209d420fb1fb05ff3f6525e1b9bc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "28201748f339fb4063799118f37b879c684ce7729ba97951dede59d3a194dde6"
    sha256 cellar: :any_skip_relocation, ventura:       "28201748f339fb4063799118f37b879c684ce7729ba97951dede59d3a194dde6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed47f6bdbf40cf2e5fbf71ce4915edd6c96e1d2678d565d3f2abb6a4743efdcf"
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