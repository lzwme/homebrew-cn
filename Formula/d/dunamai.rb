class Dunamai < Formula
  desc "Dynamic version generation"
  homepage "https:github.commtkennerlydunamai"
  url "https:files.pythonhosted.orgpackages7992288901fe54e995673551f177f067d476df3596ba56c6d5e77143c3a0fda2dunamai-1.19.1.tar.gz"
  sha256 "c8112efec15cd1a8e0384d5d6f3be97a01bf7bc45b54069533856aaaa33a9b9e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbdf050b9b6f03af7435052ffea0bab9dafdea791e0bf5e1bb9b91c5268e16a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1fd4a33fbc46dd893e2bab3696b9c76fcfe9b57d798b611913c38e911cb6501"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebc0900acc35d674bc9d7cfca0522be6a219d082022fa0c267de46885c577774"
    sha256 cellar: :any_skip_relocation, sonoma:         "6465173f21d19c827b46ab26bb673e632c28f6874ad461f922ff92128d8c3cb0"
    sha256 cellar: :any_skip_relocation, ventura:        "09ff4a23047aa72113ac293cd628556e13facaa951d39ce0cdb86de3090c29c7"
    sha256 cellar: :any_skip_relocation, monterey:       "b08461962e75af30021d728c0ef33745d550f8deadd558a593c7c448e38b4e97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "704a242530a1e90152af64e0e2ab14205b65950c517f011a573005f5e2650291"
  end

  depends_on "poetry" => :build
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    site_packages = Language::Python.site_packages(python3)
    ENV.prepend_path "PYTHONPATH", Formula["poetry"].opt_libexecsite_packages

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"
    system "git", "tag", "v0.1"
    assert_equal "0.1", shell_output("#{bin}dunamai from any").chomp
  end
end