class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https:github.comsysidbkmr"
  url "https:github.comsysidbkmrarchiverefstagsv4.21.0.tar.gz"
  sha256 "682e2a458596a9c4a93281f401a88eff2e8df08d5ae135317445bf2f2315b431"
  license "BSD-3-Clause"
  head "https:github.comsysidbkmr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7ebb45ac51a5757c61864b44c4d7e6126b795e75c00311e502923128ed77e76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "238aa425a0cae86bfc363947f440d5dd2bb7e057f6fdda3a705de4975e3ff1c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "289bcfc7a611a457b20017d200ff839acf52c8a25530be726e17333b80006fed"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcb879a57c5172d7dfd09faf0f3f2b946d0a6a4c027d9322022b2f78939106c5"
    sha256 cellar: :any_skip_relocation, ventura:       "bc4c7887fd10fe39d53cb80f06391d8b8ab30727d6c433f4e5670a239a7fae09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad125a883f6e54d541544b1da612a2679f70a3155dbf07a6e3e5606f0edb2cc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb2bd069c208584ad0cebd7abe3dffdefe44c01c502655069bbf8fa7d40c75e2"
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