class Teller < Formula
  desc "Secrets management tool for developers built in Go"
  homepage "https:github.comtelleropsteller"
  url "https:github.comtelleropstellerarchiverefstagsv2.0.5.tar.gz"
  sha256 "736bfe5781c85f02b56dba9e987016510918a5b951b56f3bf1e42f291ce32f59"
  license "Apache-2.0"
  head "https:github.comtelleropsteller.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d71b2de62640aa1c84c2cf95a9abc8c6386e2376b313c6f48f1d05522e35839"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9bcfda740ad04c1425e0ef35291dd1e418d217bdae98ea5ee72c634fbb5b9cc0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ac97211aefb33dcad5b9a42fc8376d979bedc5b2f7b3f37e0814c2febb13d7c"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc8c6b0cd51a83c1cd732d4dc3fe52ba2363818ff69a4a57e10f57679cb71196"
    sha256 cellar: :any_skip_relocation, ventura:        "e1fcd698027c6d43dbfdd43947ef3d47bb4f2bed1b72bcd145180ede72e2cb09"
    sha256 cellar: :any_skip_relocation, monterey:       "25f0e6c0022f12acec79a06afb1d544847ef772dce46957d42b33471dfb92343"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab01fcffefb4752208146f64fc14d378d7e78d777aa099a28f8ce680d99b443e"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "teller-cli")
  end

  test do
    (testpath"test.env").write <<~EOS
      foo=bar
    EOS

    (testpath".teller.yml").write <<~EOS
      project: brewtest
      providers:
        # this will fuse vars with the below .env file
        # use if you'd like to grab secrets from outside of the project tree
        dotenv:
          kind: dotenv
          maps:
          - id: one
            path: #{testpath}test.env
    EOS

    output = shell_output("#{bin}teller -c #{testpath}.teller.yml show 2>&1")
    assert_match "[dotenv (dotenv)]: foo = ba", output

    assert_match version.to_s, shell_output("#{bin}teller --version")
  end
end