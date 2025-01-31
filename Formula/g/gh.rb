class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https:cli.github.com"
  url "https:github.comclicliarchiverefstagsv2.66.0.tar.gz"
  sha256 "a16b234cafc7392b3eac17ad286bd1b19ee318db2d02f0364108fdc78304130b"
  license "MIT"
  head "https:github.comclicli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65b59fc9ca73f2c735b08cc50d187e3e48677f4f49234fe20a7652184621a17a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65b59fc9ca73f2c735b08cc50d187e3e48677f4f49234fe20a7652184621a17a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65b59fc9ca73f2c735b08cc50d187e3e48677f4f49234fe20a7652184621a17a"
    sha256 cellar: :any_skip_relocation, sonoma:        "151caaf0f8e198530f6398a3e5bdecf5c53a7451b6a1bfed353c1b2dd21ab914"
    sha256 cellar: :any_skip_relocation, ventura:       "c2f355acf4bab06d5ba26a199fb426b4482e6e7830f12a97f0e1b3d3cdbe809f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "345192fbd963a080754228b9c8183d31861a0af59bcea654dcc362d5e8c36807"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    gh_version = if build.stable?
      version.to_s
    else
      Utils.safe_popen_read("git", "describe", "--tags", "--dirty").chomp
    end

    with_env(
      "GH_VERSION" => gh_version,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=clicli",
    ) do
      system "make", "bingh", "manpages"
    end
    bin.install "bingh"
    man1.install Dir["sharemanman1gh*.1"]
    generate_completions_from_executable(bin"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}gh pr 2>&1")
  end
end