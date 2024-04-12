class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https:railway.app"
  url "https:github.comrailwayappcliarchiverefstagsv3.6.0.tar.gz"
  sha256 "45c532ef34bd8c02b169077783176c3632bfde24fcb4cf134cd95a0477099ae6"
  license "MIT"
  head "https:github.comrailwayappcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e71102cbaed3c6a58b6d1477e6e36b74f25631c64aefa9e95125f75c73e3430a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d06efae87cf8c87d9c553e95f740c879aee22d8f83af050085cf0f1cce8a2f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98ffcd8c239342f261640d41fb3ef2cfb377083b4d72f80f0b8dc6e27933cfc8"
    sha256 cellar: :any_skip_relocation, sonoma:         "2093fdda46ac030925f3a61c402e9a511cfce6f6347815a80430468764542fe5"
    sha256 cellar: :any_skip_relocation, ventura:        "60f005ec1f21a1bef535b5b209369e50dbd2f97200ae68752907659ed41e512f"
    sha256 cellar: :any_skip_relocation, monterey:       "0b78936daae52cfa51e2f1ed14658420623628a9476cda38f1ad3c00043e953b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e053d6d30e8a3bbaa779941b5c5718d3550256e51df8fb05458d43f92e9c7e6"
  end

  depends_on "rust" => :build

  # patch release version, upstream PR ref, https:github.comrailwayappclipull488
  patch do
    url "https:github.comrailwayappclicommit6ce78727cbb41866e4c828347fb1cde6d6c505d6.patch?full_index=1"
    sha256 "1b982ce319217cd6ca927e6cb8b2c984f124497f4be95bb7f3b2cf5de5603abd"
  end

  def install
    system "cargo", "install", *std_cargo_args

    # Install shell completions
    generate_completions_from_executable(bin"railway", "completion")
  end

  test do
    output = shell_output("#{bin}railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}railway --version").chomp
  end
end