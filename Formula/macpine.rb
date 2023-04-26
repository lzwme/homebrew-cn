class Macpine < Formula
  desc "Lightweight Linux VMs on MacOS"
  homepage "https://beringresearch.github.io/macpine/"
  url "https://ghproxy.com/https://github.com/beringresearch/macpine/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "7015f76d2db5a8645558c946dbb1cdf7a257d1078c4ae5678a35a1bff4cee36c"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7640228927a21311c8aaf9384abc0b217f8f2c9b84e002ad44fd440f7d6c3d38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fa9ce34475c0d63d8b9af71faa94af4e18a7f42b3ef8e57c00660ba06ea604a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a10039497379b91de1e18d736b6c486bc1c1233054da624a480ecc80c6cbe556"
    sha256 cellar: :any_skip_relocation, ventura:        "e86d45e8269b91804168d129943f2fd8f5a109b2cc3d7929c33030d107409519"
    sha256 cellar: :any_skip_relocation, monterey:       "947d56a5fee6ab0c143e94e947ecc63465524fcbd51b7a78b9d646e434a74804"
    sha256 cellar: :any_skip_relocation, big_sur:        "704a2170089e8dbeca05b46affd1bd0f32c1d126c0477b92d788d1207390febe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f41f4d7b843abee4b76eb8f81c92aca0e7db7294459c55f434bcf6d03aef7e8"
  end

  depends_on "go" => :build
  depends_on "qemu"

  conflicts_with "alpine", because: "both install `alpine` binaries"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    generate_completions_from_executable(bin/"alpine", "completion", base_name: "alpine")
  end

  service do
    run macos: [opt_bin/"alpine", "start", "+launchctl-autostart"]
    environment_variables PATH: std_service_path_env
  end

  test do
    assert_match "NAME STATUS SSH PORTS ARCH PID TAGS \n", shell_output("#{bin}/alpine list")
  end
end