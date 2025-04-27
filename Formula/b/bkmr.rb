class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https:github.comsysidbkmr"
  url "https:github.comsysidbkmrarchiverefstagsv4.20.2.tar.gz"
  sha256 "400312d40f8762ee3c10934ef3d456b38760703a493ed7127e9eaec19b9b3c34"
  license "BSD-3-Clause"
  head "https:github.comsysidbkmr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0c915216e295fae352f31115e3ee0ceefc28e414c8c0120f768688df1fadeb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f05a9d1f546fecb3e85d901a4d8fca8268b2704f6880be79eb07a028244fb886"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3f980396142df86dfe510c8fa0a4efc31ce4d5b26794c7f4f015590db74bafa"
    sha256 cellar: :any_skip_relocation, sonoma:        "0233ddcb039b60c30594c741ccdef9f16b206092073b9e3d2ad8f8dfa9c42119"
    sha256 cellar: :any_skip_relocation, ventura:       "ebbcf791b6b5df693121f5172186f6f87a6106f1c7e8b9ffde3c9603625b766c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2376685ffe84d40e6b6b567894e974bf684b5885a07caa426eba08da0869ab97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72c4cea14fc78c5fff04ddde794110b356651d6e0b196ede471fe7ebb8ae1319"
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