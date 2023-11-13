class Jinja2Cli < Formula
  include Language::Python::Virtualenv

  desc "CLI for the Jinja2 templating language"
  homepage "https://github.com/mattrobenolt/jinja2-cli"
  url "https://files.pythonhosted.org/packages/a4/22/c922839761b311b72ccc95c2ca2239311a3e80916458878962626f96922a/jinja2-cli-0.8.2.tar.gz"
  sha256 "a16bb1454111128e206f568c95938cdef5b5a139929378f72bb8cf6179e18e50"
  license "BSD-2-Clause"

  bottle do
    rebuild 5
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a9d940cebae588965a188d9fd72b11e7bfd76fa3faf2cebcfbde2b12ce38525"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "995aae35f9fb72bb98bfe7e52388b8bfb2e5e714378f2502861b010209cd2f8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e83b2c66fb4c595a9394d308ebbaa95d431664bd31d4c9fff2f82278ad5d0e2f"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ddbc456312405fc3aad5aded56fb1216dd78a0975e7d48182e10230f1cf5628"
    sha256 cellar: :any_skip_relocation, ventura:        "f04b1ecd4ada0008f29dde74955edda40815f79593fa729b12ea2e64e6374c34"
    sha256 cellar: :any_skip_relocation, monterey:       "8d9909f1b8733cd19deb40c5184681b324026368e8ba7de156dcac2fa2fb4cb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "188e80295f8a89c064d396711547d18b806421c527e46e1eff93b7a0093bd570"
  end

  depends_on "python-jinja"
  depends_on "python-markupsafe"
  depends_on "python-toml"
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = if OS.mac?
      shell_output("script -q /dev/null #{bin}/jinja2 --version")
    else
      shell_output("script -q /dev/null -e -c \"#{bin}/jinja2 --version\"")
    end
    assert_match version.to_s, output
    expected_result = <<~EOS
      The Beatles:
      - Ringo Starr
      - George Harrison
      - Paul McCartney
      - John Lennon
    EOS
    template_file = testpath/"my-template.tmpl"
    template_file.write <<~EOS
      {{ band.name }}:
      {% for member in band.members -%}
      - {{ member.first_name }} {{ member.last_name }}
      {% endfor -%}
    EOS
    template_variables_file = testpath/"my-template-variables.json"
    template_variables_file.write <<~EOS
      {
        "band": {
          "name": "The Beatles",
          "members": [
            {"first_name": "Ringo",  "last_name": "Starr"},
            {"first_name": "George", "last_name": "Harrison"},
            {"first_name": "Paul",   "last_name": "McCartney"},
            {"first_name": "John",   "last_name": "Lennon"}
          ]
        }
      }
    EOS
    output = shell_output("#{bin}/jinja2 #{template_file} #{template_variables_file}")
    assert_equal output, expected_result
  end
end