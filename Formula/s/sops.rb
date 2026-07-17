class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://getsops.io/"
  url "https://ghfast.top/https://github.com/getsops/sops/archive/refs/tags/v3.13.2.tar.gz"
  sha256 "79560b53814e20031d094a293d6c169314eaaf97efd6e95a6d765e61e881db2c"
  license "MPL-2.0"
  head "https://github.com/getsops/sops.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc11451cfbe8f928775eab952a21b8c48d640ba561da47baf187ece72361e9c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc11451cfbe8f928775eab952a21b8c48d640ba561da47baf187ece72361e9c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc11451cfbe8f928775eab952a21b8c48d640ba561da47baf187ece72361e9c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed164601ec927a8e91ef5a3835349274dcc3d22f4a5dd3abf623135e05d4156e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9747900e05c658c2183dc8c7a8dd1ecc6a5e5a2c04a920cc81e121e8ce850fbd"
    sha256 cellar: :any,                 x86_64_linux:  "f950c752bed97c47c6a27fa9e8edf84c60de040cfd7ce7b7bf791ea48b50b467"
  end

  depends_on "go" => :build

  # Fix completion script
  patch do
    url "https://github.com/getsops/sops/commit/fedcba3c01bbd6897a4700993dfd6475241ee10a.patch?full_index=1"
    sha256 "ff086e2c17c7de93211c70fbea744dc67006625a2961b649bc504aa095c0c18e"
    type :unofficial
    resolves "https://github.com/getsops/sops/issues/2252"
  end

  def install
    ldflags = "-s -w -X github.com/getsops/sops/v3/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/sops"

    pkgshare.install "example.yaml"

    generate_completions_from_executable(bin/"sops", shell_parameter_format: :cobra, shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sops --version")

    expected = "Recovery failed because no master key was able to decrypt the file."
    assert_match expected, shell_output("#{bin}/sops #{pkgshare}/example.yaml 2>&1", 128)
  end
end