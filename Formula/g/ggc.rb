class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://ghfast.top/https://github.com/bmf-san/ggc/archive/refs/tags/v8.5.2.tar.gz"
  sha256 "c5cbd0578979b6bf67127140242e8b25b664e7ab84097e6bff5afcb95c824bbf"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea23306c37e4f34ff442c2f9f11214bd2fdf8e95188f41680ce1b7e4affb7ad0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea23306c37e4f34ff442c2f9f11214bd2fdf8e95188f41680ce1b7e4affb7ad0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea23306c37e4f34ff442c2f9f11214bd2fdf8e95188f41680ce1b7e4affb7ad0"
    sha256 cellar: :any_skip_relocation, sonoma:        "56089980868602e80af2f8837e3f6c5171cb764e3523e103b05f469526b5b363"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36920471df13f79ba6149df1e755ed79d7ed591acc2b0cbdbcc501e3b5bfe79d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfae362348a383f0e538d92b09a6441266c4bfef7b354ba1e8db6c65442ed432"
  end

  depends_on "go" => :build

  uses_from_macos "vim"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")
    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end