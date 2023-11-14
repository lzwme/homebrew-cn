class GiDocgen < Formula
  include Language::Python::Virtualenv

  desc "Documentation tool for GObject-based libraries"
  homepage "https://gnome.pages.gitlab.gnome.org/gi-docgen/"
  url "https://files.pythonhosted.org/packages/29/72/a319bce143e5d10677bc89b66e750c1511ec005c7a8bb098b415cc68ac68/gi-docgen-2023.1.tar.gz"
  sha256 "88adeda9cbf882569479701eada009afa5d94fa29d728653ec388c32035f7fa3"
  license any_of: ["Apache-2.0", "GPL-3.0-or-later"]
  head "https://gitlab.gnome.org/GNOME/gi-docgen.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46217aee749a6691dfbcec02af97e8ad6834553fa1ad591dcacb5e8eba1c9688"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91811775d0906814c9c9004023c184ce5e5e71bcadfa6b35edf33c7a71bdd17c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b3b00b09a055ce0f82f330697b45025d169f4afda2df7225e08c0e8dc738a81"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d4592669e57cad57601795f0dd4ef0bb4975627a89e36e1a043271e6ea44c21"
    sha256 cellar: :any_skip_relocation, ventura:        "f5571b1de9e123f0153e14c5e834fe53ff1fe25219be0fb60db3d3931f0ba967"
    sha256 cellar: :any_skip_relocation, monterey:       "7f15ec32dee46b8a27d15d9ad99865b4fa8be6b3f9fe555f3584bd0cf7d52440"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b89c27fca95bcc0b90b423c3d3414802ba13b5e710977219b11bb89ae40f706"
  end

  depends_on "pygments"
  depends_on "python-jinja"
  depends_on "python-markdown"
  depends_on "python-markupsafe"
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