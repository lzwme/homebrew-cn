class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://owasp.org/www-project-noir/"
  url "https://ghfast.top/https://github.com/owasp-noir/noir/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "89da1991fc99c1bc2d71d10fc7d3c2a329ef89aa98c39194b714df9a85ac4bd5"
  license "MIT"
  head "https://github.com/owasp-noir/noir.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d10374f0ca0c41d1bb9e503edf672c96354ec19f498b9bad7c14f8582a6a0382"
    sha256 cellar: :any,                 arm64_sequoia: "f3d9012b46e9ba270cd98bfdc790c17b6d76572a2da92b021c39b57016cf435c"
    sha256 cellar: :any,                 arm64_sonoma:  "aed81243108e6333ec92407725cb1155e1ace55bd66074827e54d1ddc2fe5651"
    sha256 cellar: :any,                 sonoma:        "9bef73cdc0aed20a1e78d4215941821b81133be704d1092021594371a5beb210"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d44ac4ef7aa6ebc393ab2ee8c947730b970c0edcb450633944449a0acf46411"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4838b3698fb45d1778d38997461666c7d6b2ff83ee5c321903910794d4ac9bcc"
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
    bin.install "bin/noir"

    generate_completions_from_executable(bin/"noir", "--generate-completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/noir --version")

    (testpath/"api.py").write <<~PYTHON
      from fastapi import FastAPI

      app = FastAPI()

      @app.get("/hello")
      def hello():
          return {"Hello": "World"}
    PYTHON

    output = shell_output("#{bin}/noir --no-color --base-path . 2>&1")
    assert_match "Generating Report.", output
    assert_match "GET /hello", output
  end
end