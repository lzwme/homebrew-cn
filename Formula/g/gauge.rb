class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https:gauge.org"
  url "https:github.comgetgaugegaugearchiverefstagsv1.6.10.tar.gz"
  sha256 "f5cbd626799a8c59cd09be9e3385f709e86f405d5c80c17165a502583171fc59"
  license "Apache-2.0"
  head "https:github.comgetgaugegauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04a17c26b6c73da83c534c80c1af7b2f9c491f6544ed334e20850b0a52581bcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6df927e2a33f88101b6583e921969c86c7673c374750e278b1e651eaf356c696"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bae88a454d2c342078199b7c4d9ab9e347820e23e48a522cf60feab9532d8f29"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac9a72842959743872e7dc399e85d554982288534818252bd4050dce44d8c568"
    sha256 cellar: :any_skip_relocation, ventura:       "621b4b98947a5f392ca86669ffad410f27483d4304f811f5a05b906132c23d82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1012bb0475af6eacf530eddd27725d9360842575ef694c2b82cc4c8c02861e6"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "buildmake.go"
    system "go", "run", "buildmake.go", "--install", "--prefix", prefix
  end

  test do
    (testpath"manifest.json").write <<~EOS
      {
        "Plugins": [
          "html-report"
        ]
      }
    EOS

    system(bin"gauge", "install")
    assert_predicate testpath".gaugeplugins", :exist?

    system(bin"gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}gauge -v 2>&1")
  end
end