class CargoShuttle < Formula
  desc "Build & ship backends without writing any infrastructure files"
  homepage "https://shuttle.dev"
  url "https://ghfast.top/https://github.com/shuttle-hq/shuttle/archive/refs/tags/v0.56.5.tar.gz"
  sha256 "5b9c36743a3cff98b803fe1e97d82cee37c9ead84f3f775ea5c17924599d7859"
  license "Apache-2.0"
  head "https://github.com/shuttle-hq/shuttle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c98a72303199eeb45e7c0e840ea3365c92a1c2098a7ee12e45c41c8d9d51c45a"
    sha256 cellar: :any,                 arm64_sonoma:  "e9a2d84c98437910a797e9c65dcf1bf797e24803702cd9e64d78bea50f26297c"
    sha256 cellar: :any,                 arm64_ventura: "5bca175d8d05ff15d68febec77320c4c32f371a6edddc767a162e2c3ff8491be"
    sha256 cellar: :any,                 sonoma:        "d276f5926fd78c335f32ddd88dad5930e06994e13af8e5546a1c786957f340b1"
    sha256 cellar: :any,                 ventura:       "c03263f93ce98fb75e596744dbb704b922819acd3445e2c757cd7e65b191c1f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5896dbce6f54bb9883f1afe1ca6bc98567faa44b19be752aa8efece7a622838"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5c7b03a8b3ea56a02a03982e4d7bfbacbc7a0fa10a62413a880950ec49b1450"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  uses_from_macos "bzip2"

  conflicts_with "shuttle-cli", because: "both install `shuttle` binaries"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args(path: "cargo-shuttle")

    # cargo-shuttle is for old platform, while shuttle is for new platform
    # see discussion in https://github.com/shuttle-hq/shuttle/pull/1878/#issuecomment-2557487417
    %w[shuttle cargo-shuttle].each do |bin_name|
      generate_completions_from_executable(bin/bin_name, "generate", "shell")
      (man1/"#{bin_name}.1").write Utils.safe_popen_read(bin/bin_name, "generate", "manpage")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shuttle --version")
    assert_match "Unauthorized", shell_output("#{bin}/shuttle account 2>&1", 1)
    output = shell_output("#{bin}/shuttle deployment status 2>&1", 1)
    assert_match "ailed to find a Rust project in this directory.", output
  end
end