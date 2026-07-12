class Faker < Formula
  include Language::Python::Virtualenv

  desc "Python-based fake data generator"
  homepage "https://faker.readthedocs.io"
  url "https://ghfast.top/https://github.com/joke2k/faker/archive/refs/tags/v40.28.1.tar.gz"
  sha256 "3d4920bd87c3bdc5cf43dc7ba6bdc95c199e91317e0a4721c9e6e761d89164f3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "85d9a4b5224c016296dfe7acd4100a6bb349707d60a76e511bc5ba3f363b5e6e"
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