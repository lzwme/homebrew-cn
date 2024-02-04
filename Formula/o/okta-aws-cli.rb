class OktaAwsCli < Formula
  desc "Okta federated identity for AWS CLI"
  homepage "https:github.comoktaokta-aws-cli"
  url "https:github.comoktaokta-aws-cliarchiverefstagsv2.0.1.tar.gz"
  sha256 "c688e50101662e2f9f256b93b871d0324ca96c546397c132cfdfcaf01ae3ae50"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "398ec3a421fbf7735ec35afb1c8e65ca166b78aab5446f87604f27f952ae7007"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "761571125d6c4522b31f4bdefefdadc72fff69fc241b319b2e62c3030b4e0fc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74b2e90a254401a9b59d279b9b35541d8f6681d7bd15f0091fa4a11a50de3e2f"
    sha256 cellar: :any_skip_relocation, sonoma:         "12d16f0fb18b2be0d19f8e6b464b1f3fbfd47941722a82dea2cb3107ff7c2bf6"
    sha256 cellar: :any_skip_relocation, ventura:        "3aa24a1feea15626291f660ba2af33966728e9a4f8433d224fd231f88bc945cb"
    sha256 cellar: :any_skip_relocation, monterey:       "0b7ea879cda3cf614042560be3bf327af572dcfa685c235fc0e6b08c621384ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6bda07e45e63670506acb23b2ea645d04fef494f42e59092abdb3b08ea2dd91"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdokta-aws-cli"
  end

  test do
    str_help = shell_output("#{bin}okta-aws-cli --help")
    assert_match "Usage:", str_help
    assert_match "Flags:", str_help
    str_error = shell_output("#{bin}okta-aws-cli -o example.org -c homebrew-test 2>&1", 1)
    assert_match 'Error: authorize received API response "404 Not Found"', str_error
  end
end