class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https:github.comphppie"
  url "https:github.comphppiereleasesdownload0.2.0pie.phar"
  sha256 "782284f528e3b729145581dcefe0cb542dca2664415f11ac7af4dc4d6e149d0d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51a35c429aaa9c8877e2d4d7b6b03e51e4216af8a01097c3abe7c7227535eab2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51a35c429aaa9c8877e2d4d7b6b03e51e4216af8a01097c3abe7c7227535eab2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "51a35c429aaa9c8877e2d4d7b6b03e51e4216af8a01097c3abe7c7227535eab2"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e6c789b3c7c9caf1747e56cda457588be30eb1ae554b8e45c5289db959169e0"
    sha256 cellar: :any_skip_relocation, ventura:       "8e6c789b3c7c9caf1747e56cda457588be30eb1ae554b8e45c5289db959169e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7feacc4a4601b99dd9a2f48b58d7394c26acf8218f0f740ea18be4e55fff141"
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