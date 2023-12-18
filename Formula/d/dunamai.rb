class Dunamai < Formula
  desc "Dynamic version generation"
  homepage "https:github.commtkennerlydunamai"
  url "https:files.pythonhosted.orgpackages1d03338fba56a6c76ea6d99ca0b7af3098292c2dd6597ed656daa6ae26a07a77dunamai-1.19.0.tar.gz"
  sha256 "6ad99ae34f7cd290550a2ef1305d2e0292e6e6b5b1b830dfc07ceb7fd35fec09"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3bdf36da31343b2b1fbd16a11d8ee822a9769207163927b066478ad535ec6bf8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "623ef3c20fbd5c99fd3d40f235cb79972b366952bd1e42d72bb86b7b2c75b4e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eeaf6e4233ade353870c8a8b9cba0c41f4182d5672cbf558914b822236f82aa8"
    sha256 cellar: :any_skip_relocation, sonoma:         "05ca3b47594995493ae9060913d67682f47892fcf23b2518bc36b9acfea19987"
    sha256 cellar: :any_skip_relocation, ventura:        "cad35d5fff9c893b62877166b98a67d65aea0e2924498458dcf10c8986c8758b"
    sha256 cellar: :any_skip_relocation, monterey:       "8a78ef790cac6b99445b13689b64e52370232973ec496cd7cf757c692398dbc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85052e3983d05901270259344adc47719cc299c97ee844c486378eede8c0ae93"
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