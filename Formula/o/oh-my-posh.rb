class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv23.15.3.tar.gz"
  sha256 "c908cc55fd0d70bbb12ba79c2f3f8107da714ae9ea8d6174a57824a8b8913713"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d753567992a7d5cd9e4fa32a5f2d06e6bd9a3b95eaa5774f8d2777de55299da0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "791603b6abc6b559b1f3c57a028b2a86f245cebb8d54319c58d298ec8a99f676"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b7d9d5a7adf7fce7fbfcd7e2b14ea1d0e8fa891b3c7deca87ebe5e79f6e8f36"
    sha256 cellar: :any_skip_relocation, sonoma:        "01d0adc658d049971898664797a2f886c18046ca97cfbce0875aa3fb2df368c5"
    sha256 cellar: :any_skip_relocation, ventura:       "84a2b1532b330cb8b9736857b97d95d7451a6d3680d217a72967f37db9a7d92b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f147c19f5f36ae896d8551585151a676d245fc01370f06c13e4b20a5fbafe5f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Version=#{version}
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh --version")
  end
end