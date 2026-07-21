class Faker < Formula
  include Language::Python::Virtualenv

  desc "Python-based fake data generator"
  homepage "https://faker.readthedocs.io"
  url "https://ghfast.top/https://github.com/joke2k/faker/archive/refs/tags/v40.32.0.tar.gz"
  sha256 "5993c3023dd73d58dd508acb644997e12d6457edc4fc997671f84ffed5d4cc22"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c80a657fc3a98cbd4005bd86c4b877131fba9abad085724cdc83bd59114fd064"
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