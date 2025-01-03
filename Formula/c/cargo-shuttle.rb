class CargoShuttle < Formula
  desc "Build & ship backends without writing any infrastructure files"
  homepage "https:shuttle.dev"
  url "https:github.comshuttle-hqshuttlearchiverefstagsv0.49.0.tar.gz"
  sha256 "fe13c6a0717edd1d6ec838c6abf02d3230b379083d4daf8f63621d47d1ceded6"
  license "Apache-2.0"
  revision 1
  head "https:github.comshuttle-hqshuttle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e4f4bcd687ba6e974b1c6752bd95bf8379b7c384ddb1e605e6694a90b115b340"
    sha256 cellar: :any,                 arm64_sonoma:  "a8d0d989c7b740ef6a1f6d0e982200cb07279c5375ee1c0639f281420eff6515"
    sha256 cellar: :any,                 arm64_ventura: "198d4256b344bb905069bcbf51103fa141816c2613e5148d1fc7c8ca02b14e40"
    sha256 cellar: :any,                 sonoma:        "614b43b6ea478ca9a49ec7ba28bd2d8e0d3aaca078850e5cb5d1b9e974a917fe"
    sha256 cellar: :any,                 ventura:       "88d63a4f34aa7568222edd899045c4005d24e946c3aa44784e7068c1a278358c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1400520b9e73b07cbb4d34ef411dbec11c7b7efaec05982447700faed19bb328"
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
    assert_match "Error: \e[1m401 Unauthorized", shell_output("#{bin}shuttle account 2>&1", 1)
    assert_match "Error: failed to get cargo metadata", shell_output("#{bin}shuttle deployment status 2>&1", 1)
  end
end