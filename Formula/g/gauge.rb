class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https:gauge.org"
  url "https:github.comgetgaugegaugearchiverefstagsv1.6.5.tar.gz"
  sha256 "467a50a0d54e3ea56274655613c3dd847e1729a1e1ecdad1a353bd80faa6adbd"
  license "Apache-2.0"
  head "https:github.comgetgaugegauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d78535e981d7a2da77dd5cab620880e3addade4015cad944b694ee036b20978b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "654e3423cbed74a76f7d8cbe0e5ac7325f577149de7daca864919dafba1d558b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbafdfd5dbba3aa021aa85d49df3d2c8f0d935e122242503e91014ce4fca9b27"
    sha256 cellar: :any_skip_relocation, sonoma:         "82ad75654685854b6c63b3272fe150b8ef105084020cca6aa75cec0d3cbcd9cb"
    sha256 cellar: :any_skip_relocation, ventura:        "2804a5b10ee2dc606c8bad22e394457ec0391023e1daaeb2a3ae55980f34e335"
    sha256 cellar: :any_skip_relocation, monterey:       "7626f775b696c95f334a4ed5b243c19ebd6eaad216e3328258fbb934893ce75d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fac83400bab8ce1d5cc07639bc9595a31b8d41373dbafb796a7109aae6b79ff5"
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

    system("#{bin}gauge", "install")
    assert_predicate testpath".gaugeplugins", :exist?

    system("#{bin}gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}gauge -v 2>&1")
  end
end