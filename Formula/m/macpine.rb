class Macpine < Formula
  desc "Lightweight Linux VMs on MacOS"
  homepage "https://beringresearch.github.io/macpine/"
  url "https://ghfast.top/https://github.com/beringresearch/macpine/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "fd2d315a6bd42c9af2c6c395d46b95731484ea1d79d1902bc919e2f95f73fe69"
  license "Apache-2.0"
  head "https://github.com/beringresearch/macpine.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)*)$/i)
    strategy :git do |tags, regex|
      tags.map do |tag|
        version = tag[regex, 1]
        next if version.blank?

        # Naively convert tags like `v.01` to `0.1`
        tag.match?(/^v\.?\d+$/i) ? version.chars.join(".") : version
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79536f41d322f793f6f611a644aa0b01992f915e4dd2e6abdffee9361c5c4879"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79536f41d322f793f6f611a644aa0b01992f915e4dd2e6abdffee9361c5c4879"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79536f41d322f793f6f611a644aa0b01992f915e4dd2e6abdffee9361c5c4879"
    sha256 cellar: :any_skip_relocation, sonoma:        "32a5ca11c6360997ba400c17eccdfd3679e9e70c6cf5750b89a5e63629dfba62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3b37fd124b125b345e77ae57005c5ae592cba756ad4420360d29f3eb16a0b3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d722c27ff45c34c10145917fac5249cacd0338081ea8b5b46b66b58c8b906b0d"
  end

  depends_on "go" => :build
  depends_on "qemu"

  conflicts_with "alpine", because: "both install `alpine` binaries"

  def install
    # bump to use go1.25, https://github.com/beringresearch/macpine/pull/223
    inreplace "go.mod", "1.23", Formula["go"].version.to_s

    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"alpine")
    generate_completions_from_executable(bin/"alpine", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  service do
    run macos: [opt_bin/"alpine", "start", "+launchctl-autostart"]
    environment_variables PATH: std_service_path_env
  end

  test do
    assert_match "NAME STATUS SSH PORTS ARCH PID TAGS \n", shell_output("#{bin}/alpine list")
  end
end