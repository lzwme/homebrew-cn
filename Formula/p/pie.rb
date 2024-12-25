class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https:github.comphppie"
  url "https:github.comphppiereleasesdownload0.3.0pie.phar"
  sha256 "06a49e2ee194d43ffa0c362c1f3306c3f458671e1976a18041fddd7859f50c83"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdb20e997f91ff345215ceee4dde30142d606df741c68828619cd6c778f378f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdb20e997f91ff345215ceee4dde30142d606df741c68828619cd6c778f378f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cdb20e997f91ff345215ceee4dde30142d606df741c68828619cd6c778f378f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "17a3fea8ede581f7f84c891abf02342d3e0edfeb290f9490ee9e4f536aa7ea8c"
    sha256 cellar: :any_skip_relocation, ventura:       "17a3fea8ede581f7f84c891abf02342d3e0edfeb290f9490ee9e4f536aa7ea8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "374978fa3c7c8e261d83ef2ab9c8baa816e10122fadf49f8dacac13ca7eb8768"
  end

  depends_on "php"

  def install
    bin.install "pie.phar" => "pie"
    generate_completions_from_executable("php", bin"pie", "completion")
  end

  test do
    system bin"pie", "build", "apcuapcu"
  end
end