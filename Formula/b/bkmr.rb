class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https:github.comsysidbkmr"
  url "https:github.comsysidbkmrarchiverefstagsv4.22.0.tar.gz"
  sha256 "f98f323060b7498376a4d5e9fc69759ccd9fac9ac5190463a73a9d1ad4069a8b"
  license "BSD-3-Clause"
  head "https:github.comsysidbkmr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb5f5c94fd33deb2797271aaa6ee63c075f4cdab24eba4c567d51029d2be174a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66c2653ba61a6598421a1f612c858527c5ff9a0fff1115837270e2f41431e762"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ccf15e03093c4675ee573d40915144f179c47bf2a764ef14899e1af8d4995f7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1584fcdc3ff5e6be384cc985a946728aa5b6158af411d80006444c1f3e70109b"
    sha256 cellar: :any_skip_relocation, ventura:       "910ecd555e20c26b8bfde7259ae8db9e23865d242d9fd1395f2ea44e8e6122be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d62da14e3ffd2fdfdea9378088db3404049b14d10b448306af1cd0a90c430ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7627ec66de3b2c227aa9b6f752558f854c96da7f1708567ff1834b8dd4e7b29"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "python"

  def install
    cd "bkmr" do
      # Ensure that the `openssl` crate picks up the intended library.
      # https:docs.rsopenssllatestopenssl#manual
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

      system "cargo", "install", *std_cargo_args
    end

    generate_completions_from_executable(bin"bkmr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}bkmr --version")

    output = shell_output("#{bin}bkmr info")
    assert_match "Database URL: #{testpath}.configbkmrbkmr.db", output
    assert_match "Database Statistics", output
  end
end