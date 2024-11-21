class Noseyparker < Formula
  desc "Finds secrets and sensitive information in textual data and Git history"
  homepage "https:github.compraetorian-incnoseyparker"
  url "https:github.compraetorian-incnoseyparkerarchiverefstagsv0.21.0.tar.gz"
  sha256 "51d2be098d41a7dc4165b35151a448d27e32300559ebd7e524f34a76202c0a9d"
  license "Apache-2.0"
  head "https:github.compraetorian-incnoseyparker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c7ba3526341d6d2b78fbdea3c3bba351e1e3c68885f70f5f775cd43e8ed323c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac1fb7ee64da882895cf4bd677b7cd17c3a1a53afb3613bbe5ce824f9f08ca0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18157c8f522d378f5d01a7d764032d1fd2946dc307ece517e1bc943e77f57e5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "cff5ae252072fe8a78f44466764e6b580ee90a3f8e116d9a99e2bd4504b7bd37"
    sha256 cellar: :any_skip_relocation, ventura:       "1377acab1ab02222a09f74bccac116623cc35d24800e5d64d43f505abd1080da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac3db148e145859ffecc26d8618e62317fa9fb3ea63500378cd42d3ca21a7150"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV["VERGEN_GIT_BRANCH"] = "main"
    ENV["VERGEN_GIT_COMMIT_TIMESTAMP"] = time.iso8601
    ENV["VERGEN_GIT_SHA"] = tap.user
    system "cargo", "install", "--features", "release", *std_cargo_args(path: "cratesnoseyparker-cli")
    mv bin"noseyparker-cli", bin"noseyparker"

    generate_completions_from_executable(bin"noseyparker", "generate", "shell-completions", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}noseyparker -V")

    output = shell_output(bin"noseyparker scan --git-url https:github.comhomebrew.github")
    assert_match "00 new matches", output
  end
end