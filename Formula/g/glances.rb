class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/a7/ba/c8da238e3a24ba13115ae70361598d999d9223001555f1f614dde59da843/glances-4.2.1.tar.gz"
  sha256 "03061c7ea7bb092d24a58b33b3f8dbe218491d9afe69e20eedc0ebe90d629545"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0aab6a02e34fa705556b8d3e3bac52fe08961f053c508fcc97a53bb06a230d4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d56ce10f26a013008fac88a44d981f317676ea9118b4a7d848e8b89c0a6547bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cda11ca75ff0a3963a8b7d25526e792dbaddee8983ac859174cdb7695f1ca893"
    sha256 cellar: :any_skip_relocation, sonoma:        "253b80b8d77e208b332a39b15d09e51b461da0447e7ed0a7fc9406d2c0b1acb8"
    sha256 cellar: :any_skip_relocation, ventura:       "464a07d6905b670d4928a7b122f6a9a5a2a3889c7915996300105e862f27e229"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27cbd2994c3ff2cd19ae28995e44e7f2984f5c6eef211526ce11bfb99b9c7a1a"
  end

  depends_on "rust" => :build # for orjson
  depends_on "python@3.13"

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/26/10/2a30b13c61e7cf937f4adf90710776b7918ed0a9c434e2c38224732af310/psutil-6.1.0.tar.gz"
    sha256 "353815f59a7f64cdaca1c0307ee13558a0512f6db064e92fe833784f08539c7a"
  end

  def install
    virtualenv_install_with_resources

    prefix.install libexec/"share"
  end

  test do
    read, write = IO.pipe
    pid = fork do
      exec bin/"glances", "-q", "--export", "csv", "--export-csv-file", "/dev/stdout", out: write
    end
    header = read.gets
    assert_match "timestamp", header
  ensure
    Process.kill("TERM", pid)
  end
end