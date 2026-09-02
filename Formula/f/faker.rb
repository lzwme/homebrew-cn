class Faker < Formula
  include Language::Python::Virtualenv

  desc "Python-based fake data generator"
  homepage "https://faker.readthedocs.io"
  url "https://ghfast.top/https://github.com/joke2k/faker/archive/refs/tags/v40.38.0.tar.gz"
  sha256 "1b7a4ebdd86f617b2918d8e87de1699a0c67f5dc5085c27041dbb0dd9463601b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "75eff537423e21c8506a436b82d348a072f6d4d3bc21aba0ee4772a4a506597d"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "{'ssn': '150-19-7120', 'name': 'Christian Blake'}",
                 shell_output("#{bin}/faker --seed 12345 profile ssn,name")
  end
end