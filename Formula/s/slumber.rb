class Slumber < Formula
  desc "Terminal-based HTTPREST client"
  homepage "https:slumber.lucaspickering.me"
  url "https:github.comLucasPickeringslumberarchiverefstagsv2.3.0.tar.gz"
  sha256 "9e3266d825180367997e2d2b049e40d74a5d1044e882a14b682bba3780d4883b"
  license "MIT"
  head "https:github.comLucasPickeringslumber.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e842474531779e2635e6fd5d76c47208fb34a696a1009f456c6331b81591e47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e306a33f2d9575638afcf39dd44ee01d41b3c22dceb382585796dab4ed3df935"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0991ac889d6cb79890263db1cc1761403c9c0130593f14a44e98f2dda6abff4"
    sha256 cellar: :any_skip_relocation, sonoma:        "260683292c481132c227db2fd7d825af6ba3f223c220573285a3ca0637009cfd"
    sha256 cellar: :any_skip_relocation, ventura:       "58399c7a2b037905ce98063e5798713c18be58e18c0ca67fbbf46653b016cab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ed2980477bdfd1df3aeb236a5d8f66b1fc800a009a456a056c8e07966067a73"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}slumber --version")

    system bin"slumber", "new"
    assert_match <<~YAML, (testpath"slumber.yml").read
      # For basic usage info, see:
      # https:slumber.lucaspickering.mebookgetting_started.html
      # For all collection options, see:
      # https:slumber.lucaspickering.mebookapirequest_collectionindex.html

      # Profiles are groups of data you can easily switch between. A common usage is
      # to define profiles for various environments of a REST service
      profiles:
        example:
          name: Example Profile
          data:
            host: https:httpbin.org
    YAML
  end
end