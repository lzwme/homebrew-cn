class GiDocgen < Formula
  include Language::Python::Virtualenv

  desc "Documentation tool for GObject-based libraries"
  homepage "https://gnome.pages.gitlab.gnome.org/gi-docgen/"
  url "https://files.pythonhosted.org/packages/e5/6e/9f05646d0dbfa537c9328204212e7d22942e656b9279d1d36d8efedf5dec/gi-docgen-2023.2.tar.gz"
  sha256 "1836b6496fdc27aff345d12bac8d4b024416a23e0745c8fe0fd38884437a1fc7"
  license any_of: ["Apache-2.0", "GPL-3.0-or-later"]
  head "https://gitlab.gnome.org/GNOME/gi-docgen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b638c87d79f220948e38fdf06613009786c2e388c6e5a2fb8e7cc7ae0b0dcaee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "415a6b670e0aeb4429fb2ee775e411c4605935c58dc8bc9379fc4d320f26772b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e34de37d53b61fb15aed46c53b63d21e504f67b923cd512735b7f14a99b6f8e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee69eecf093b1879dd8af20391e4a67a21ae20ace51d694125ad1f0528189676"
    sha256 cellar: :any_skip_relocation, ventura:        "4e1f48296666669ab0caf1a87819eb44743966dab8f2aaecf3750e7f8b1e7c2c"
    sha256 cellar: :any_skip_relocation, monterey:       "33484b2a7c2dc3a8f3d01fa434768bb6db9cd6d83f8883647620eb87480da71c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8689b47d280d7120f2baa4385a449efd308bfecb8cb5b06462a4f9b8ff02459b"
  end

  depends_on "pygments"
  depends_on "python-jinja"
  depends_on "python-markdown"
  depends_on "python-markupsafe"
  depends_on "python-packaging"
  depends_on "python@3.12"

  # Source for latest version is not available on PyPI, so using GitHub tarball instead.
  # Issue ref: https://github.com/leohemsted/smartypants.py/issues/8
  resource "smartypants" do
    url "https://ghproxy.com/https://github.com/leohemsted/smartypants.py/archive/refs/tags/v2.0.1.tar.gz"
    sha256 "b98191911ff3b4144ef8ad53e776a2d0ad24bd508a905c6ce523597c40022773"
  end

  resource "typogrify" do
    url "https://files.pythonhosted.org/packages/8a/bf/64959d6187d42472acb846bcf462347c9124952c05bd57e5769d5f28f9a6/typogrify-2.0.7.tar.gz"
    sha256 "8be4668cda434163ce229d87ca273a11922cb1614cb359970b7dc96eed13cb38"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"brew.toml").write <<~EOS
      [library]
      description = "Homebrew gi-docgen formula test"
      authors = "Homebrew"
      license = "BSD-2-Clause"
      browse_url = "https://github.com/Homebrew/brew"
      repository_url = "https://github.com/Homebrew/brew.git"
      website_url = "https://brew.sh/"
    EOS

    (testpath/"brew.gir").write <<~EOS
      <?xml version="1.0"?>
      <repository version="1.2"
                  xmlns="http://www.gtk.org/introspection/core/1.0"
                  xmlns:c="http://www.gtk.org/introspection/c/1.0">
        <namespace name="brew" version="1.0" c:identifier-prefixes="brew" c:symbol-prefixes="brew">
          <record name="Formula" c:type="Formula">
            <field name="name" writable="1">
              <type name="utf8" c:type="char*"/>
            </field>
          </record>
        </namespace>
      </repository>
    EOS

    output = shell_output("#{bin}/gi-docgen generate -C brew.toml brew.gir")
    assert_match "Creating namespace index file for brew-1.0", output
    assert_predicate testpath/"brew-1.0/index.html", :exist?
    assert_predicate testpath/"brew-1.0/struct.Formula.html", :exist?
    assert_match %r{Website.*>https://brew.sh/}, (testpath/"brew-1.0/index.html").read
    assert_match(/struct.*Formula.*{/, (testpath/"brew-1.0/struct.Formula.html").read)
  end
end