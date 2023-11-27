class GiDocgen < Formula
  include Language::Python::Virtualenv

  desc "Documentation tool for GObject-based libraries"
  homepage "https://gnome.pages.gitlab.gnome.org/gi-docgen/"
  url "https://files.pythonhosted.org/packages/ec/4e/7ae06ba557a1ef86abcf33c299bf955a4cf69f0b8f6268c6e97029b6329f/gi-docgen-2023.3.tar.gz"
  sha256 "977616bcc0e2735bb596c71e8eb34533526680740c666e87f9dfc323acd488f0"
  license any_of: ["Apache-2.0", "GPL-3.0-or-later"]
  head "https://gitlab.gnome.org/GNOME/gi-docgen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ffaa25a68185527d542c6bf763029ba7596c65511472cbb89d63fd4d25c8982"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef0803489a89d5c0bc4c28062ccd034e292c7ed39845a741f6eee2e443226025"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86c1ed75f3b0141ca6529d68bfad595d3c0c65fc83d3d90e9a4d1f236ff8d824"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ab5eb00b893d72ca66ad946724d4d698efdd99f1a4c3463ade278c9024af644"
    sha256 cellar: :any_skip_relocation, ventura:        "28715df65c4ce5e659d870f9c682930109ff988c00f5066ba9775e04e856c45e"
    sha256 cellar: :any_skip_relocation, monterey:       "482c9adda5ff0f413b8dfad80c473c69707652605e30329d9ea7058b8d192e19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a371787a3b4b7258835b0203dc0ece4ce6bda83a1e18304223524437936150ae"
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