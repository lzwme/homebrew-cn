class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.5.13.tar.gz"
  sha256 "a84601f38b4a7039cc8d39dc5bb6472a05566b7c680bb66835fab9a1a61703f3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ceb11dd04a8aea5039cdd78b9475bbae233d906131567fdcb48a5f6d8fe5c1ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f59ef8118538c7a80b69d27a8b8df882433951519c4173c05705e9b46a8e40c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c42d707b0acfa03dd341760ee0439d935757a8f4b425d61c8108831afe74a73"
    sha256 cellar: :any,                 arm64_linux:   "f3dcdde1bd0042c2edbf1b40f34b5bbedb9afb58c5faa5eb0a5c958c6985dc00"
    sha256 cellar: :any,                 x86_64_linux:  "ee1bede99db993df1ff9a21f00b13ae0774f5e0ab61833c1599b8ae2a663312e"
  end

  depends_on "rust" => :build

  def install
    # Work around SIGKILL on arm64 linux runner from fat LTO
    github_arm64_linux = OS.linux? && Hardware::CPU.arm? &&
                         ENV["HOMEBREW_GITHUB_ACTIONS"].present? &&
                         ENV["GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED"].blank?
    ENV["CARGO_PROFILE_RELEASE_LTO"] = "thin" if github_arm64_linux
    ENV["BIOME_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "crates/biome_cli")
  end

  test do
    (testpath/"test.js").write("const x = 1")
    system bin/"biome", "format", "--semicolons=always", "--write", testpath/"test.js"
    assert_match "const x = 1;", (testpath/"test.js").read

    assert_match version.to_s, shell_output("#{bin}/biome --version")
  end
end