class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https:www.apollographql.comdocsrover"
  url "https:github.comapollographqlroverarchiverefstagsv0.31.2.tar.gz"
  sha256 "2392779d44d62c120f875fd137ec329edbde58c73b83c3548e66750d313b25cb"
  license "MIT"
  head "https:github.comapollographqlrover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60461e449425f9f174fa23735ae59688e11ad9419ff8fc4eb5e0286cd8e8d1d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be8e45af7a6c3b6d034c7706e4a80349c246192755caead4983c99beede07bcc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b21cb2b86bb6ae90b3c40b1a54983b60bca064c67d12953f173102154fb2d41"
    sha256 cellar: :any_skip_relocation, sonoma:        "a60cb11e49237a45d7fa502d8da3535a82dfbce7b3b67e76e803e82710f88d29"
    sha256 cellar: :any_skip_relocation, ventura:       "cec9e87732f3bee4570d2e97ff17f6f15585c08bd266c4c2d871ef7ff6b3b6b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3dd269f2eb299142d86c5209b48ee20c5d10dc82582a8f5840e46c29dc15c58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e49642fdba28b62d2e23c98d53496f6849cc6b0efcaad7592c80de4412dce60c"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}rover graph introspect https:graphqlzero.almansi.meapi")
    assert_match "directive @specifiedBy", output

    assert_match version.to_s, shell_output("#{bin}rover --version")
  end
end