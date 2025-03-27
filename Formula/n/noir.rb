class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https:owasp.orgwww-project-noir"
  url "https:github.comowasp-noirnoirarchiverefstagsv0.20.1.tar.gz"
  sha256 "c06a5bbd80ac30b5ba279312875f0256cec5e9b9bdc7aa96023b3aa4a9baac64"
  license "MIT"
  head "https:github.comowasp-noirnoir.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "24edfa56dd6f9dba5d484fb4b578c68c4280d57af928f98f28d50599cd8ff4a2"
    sha256 cellar: :any,                 arm64_sonoma:  "ef140edee3db2a24e182b9e5b30a7bc4e24c00fbe9a844a7230f64f43e5b2d2b"
    sha256 cellar: :any,                 arm64_ventura: "449a3520f4d399b40665bf5e2378ba009271921b09bf2701d27641bc94ce9462"
    sha256 cellar: :any,                 sonoma:        "776ce55d17dbfd2303166808c3b122d71e2ee414d2c1cf4702d53021f20be0b1"
    sha256 cellar: :any,                 ventura:       "f2863664d4fad75710a8079e737f588eb4ccdf98b8940fe3cd1e59c9e2e6c461"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56e142b5a072d75a7c1eeddf3abcc25de1c140f67be32282ff72f13efc01f355"
  end

  depends_on "crystal" => :build
  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "zlib"

  def install
    system "shards", "build", "--production", "--release", "--no-debug"
    bin.install "binnoir"

    generate_completions_from_executable(bin"noir", "--generate-completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}noir --version")

    (testpath"api.py").write <<~PYTHON
      from fastapi import FastAPI

      app = FastAPI()

      @app.get("hello")
      def hello():
          return {"Hello": "World"}
    PYTHON

    output = shell_output("#{bin}noir --no-color --base-path . 2>&1")
    assert_match "Generating Report.", output
    assert_match "GET hello", output
  end
end