class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https:owasp.orgwww-project-noir"
  url "https:github.comowasp-noirnoirarchiverefstagsv0.20.0.tar.gz"
  sha256 "b73790bd69ee02e247cbf0ca3fcbf56988c8474fa0cc0f7d066af7ca03c039df"
  license "MIT"
  head "https:github.comowasp-noirnoir.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fc0b727586ede65a17d4cc99204ae55b440f14e9e907ced2b4e75795fe363d71"
    sha256 cellar: :any,                 arm64_sonoma:  "1b722a0785f7f47f5399755bbc93ec610fbc91707c1b8a2acbf749bf12f3db51"
    sha256 cellar: :any,                 arm64_ventura: "571bcbcb602b4b1937cf6a2bea843fbc88a5a8acd63dde303b8ded4a3d216cc1"
    sha256 cellar: :any,                 sonoma:        "38d3f38212bafa1e47de574ae5956687a6afb3efb096a14da8ae47ed96e4dae0"
    sha256 cellar: :any,                 ventura:       "c3352d22a0aae2bd464d4fdfda918d94c5023331ef9274a0723fae8cf27f98d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c23b8db1580dc7862385ccdbf4015922f3303b3df5391ef488d3adbe83d0e80"
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