class CargoShuttle < Formula
  desc "Build & ship backends without writing any infrastructure files"
  homepage "https:shuttle.dev"
  url "https:github.comshuttle-hqshuttlearchiverefstagsv0.50.0.tar.gz"
  sha256 "25dd018a61debf6cb84de0085646367185912f1db8441a3b6a177a8365d8de42"
  license "Apache-2.0"
  head "https:github.comshuttle-hqshuttle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dee6030d95b95eb1a065ee2549fe8dad1ec3fbd4e108bd220410d1a5fd306efe"
    sha256 cellar: :any,                 arm64_sonoma:  "3cbcc79fd0183e4cc3a78256a11ad10502de73422e1eca6d2e32073a56626fec"
    sha256 cellar: :any,                 arm64_ventura: "0ab8c2ade8bb5502ada4552874fd9c753d68208f06c04485bff4e73f193c3f78"
    sha256 cellar: :any,                 sonoma:        "0e62e0736cee8d62d1eef65fc2666723badb4bce7cfaf78601240e59985555e7"
    sha256 cellar: :any,                 ventura:       "0170d9041172d544237378180b4d039decb1a807ab9e683a7c512acd727b215b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b849a5edaf31e0204d0c1e7da671143d1f684443a41e3622b6dd49760430852c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.8" # needs https:github.comrust-langgit2-rsissues1109 to support libgit2 1.9

  uses_from_macos "bzip2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args(path: "cargo-shuttle")

    # cargo-shuttle is for old platform, while shuttle is for new platform
    # see discussion in https:github.comshuttle-hqshuttlepull1878#issuecomment-2557487417
    %w[shuttle cargo-shuttle].each do |bin_name|
      generate_completions_from_executable(binbin_name, "generate", "shell")
      (man1"#{bin_name}.1").write Utils.safe_popen_read(binbin_name, "generate", "manpage")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}shuttle --version")
    assert_match "Forbidden", shell_output("#{bin}shuttle account 2>&1", 1)
    assert_match "Error: failed to get cargo metadata", shell_output("#{bin}shuttle deployment status 2>&1", 1)
  end
end