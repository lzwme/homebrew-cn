class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https:github.comphppie"
  url "https:github.comphppiereleasesdownload0.4.0pie.phar"
  sha256 "3d8183493a7b16d4530778f2ad2209d113ba4dc15a0fa19600678b6c59ae3ed0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dac20a633f550d07eff58167a0eea0a8f8e3d69894e7b37cfe05a889faeba23d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dac20a633f550d07eff58167a0eea0a8f8e3d69894e7b37cfe05a889faeba23d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dac20a633f550d07eff58167a0eea0a8f8e3d69894e7b37cfe05a889faeba23d"
    sha256 cellar: :any_skip_relocation, sonoma:        "20b3ff96bcf6171294536c8d72c4b25b3ab5584e0791e94c8a74d1998872b5f0"
    sha256 cellar: :any_skip_relocation, ventura:       "20b3ff96bcf6171294536c8d72c4b25b3ab5584e0791e94c8a74d1998872b5f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8ae95dd048c0d3075a7ca0569cf2fb456ff4007d5ee0144fa60df583e8a82bd"
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