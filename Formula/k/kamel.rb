class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https:camel.apache.org"
  url "https:github.comapachecamel-karchiverefstagsv2.5.1.tar.gz"
  sha256 "79fa72a94a05720e179bd669181ceaed37aca24d6ae6fe82f3b7638882029f40"
  license "Apache-2.0"
  head "https:github.comapachecamel-k.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12933050090c7c96a7bc0b0a11a486050f26b14fd56fd4f663f1d84e9f032b81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12933050090c7c96a7bc0b0a11a486050f26b14fd56fd4f663f1d84e9f032b81"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12933050090c7c96a7bc0b0a11a486050f26b14fd56fd4f663f1d84e9f032b81"
    sha256 cellar: :any_skip_relocation, sonoma:        "51d29ee632a4a2309086b0e5e4d13a5df27fe1bd881b3d77a900c4f29edc42bc"
    sha256 cellar: :any_skip_relocation, ventura:       "51d29ee632a4a2309086b0e5e4d13a5df27fe1bd881b3d77a900c4f29edc42bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "942e1b341f9cfe7517eabc15c4ab3de262f035e06dc78026c8b327c13c9aa6e5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comapachecamel-kv2pkgutildefaults.GitCommit=#{tap.user}-#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdkamel"

    generate_completions_from_executable(bin"kamel", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}kamel 2>&1")
    assert_match "Apache Camel K is a lightweight", run_output

    help_output = shell_output("echo $(#{bin}kamel help 2>&1)")
    assert_match "kamel [command] --help", help_output.chomp

    get_output = shell_output("echo $(#{bin}kamel get 2>&1)")
    assert_match "Error: cannot get command client: invalid configuration", get_output

    version_output = shell_output("echo $(#{bin}kamel version 2>&1)")
    assert_match version.to_s, version_output

    reset_output = shell_output("echo $(#{bin}kamel reset 2>&1)")
    assert_match "Error: cannot get command client: invalid configuration", reset_output

    rebuild_output = shell_output("echo $(#{bin}kamel rebuild 2>&1)")
    assert_match "Error: cannot get command client: invalid configuration", rebuild_output

    reset_output = shell_output("echo $(#{bin}kamel reset 2>&1)")
    assert_match "Error: cannot get command client: invalid configuration", reset_output
  end
end