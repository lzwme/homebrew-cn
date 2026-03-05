class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://ghfast.top/https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.61.1.tar.gz"
  sha256 "fe82a03b4420eefcbd070c271f11ff07b6e6905f385c7c1f7688f34bb16e0804"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "097406f8155f80940a93b6b43d0e88281ecfbe18c9c351e6aa848ecd046f9cfa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b845942e42a7c5cb7b5de0368c72aafc4bae43b255972b4358aaf60b48d0f84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0be18532babcdc02f65a569bf227b6902993f2aa01b391d69674733d64dd72cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e350dda9e7770b9c7aa4372edaea9ce2a65266a630c595514f7aecb1dd3512d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81d75ef1298489444d354764303ce0fdc913d54db14b1e0f4f9fb67ad74f82e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45e672806f45b110c906deec7378369aa5a6c130030013f43c00bd3075e60ce7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/filebrowser/filebrowser/v2/version.Version=#{version}
      -X github.com/filebrowser/filebrowser/v2/version.CommitSHA=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"filebrowser", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filebrowser version")

    system bin/"filebrowser", "config", "init"
    assert_path_exists testpath/"filebrowser.db"

    output = shell_output("#{bin}/filebrowser config cat 2>&1")
    assert_match "Using database: #{testpath}/filebrowser.db", output
  end
end