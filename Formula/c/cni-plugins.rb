class CniPlugins < Formula
  desc "Container Network Interface plugins"
  homepage "https://www.cni.dev"
  url "https://ghfast.top/https://github.com/containernetworking/plugins/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "5091841a4f379ab6159152b546efc4523d55694c8adc4f19cc7c68f9d1db6d75"
  license "Apache-2.0"
  head "https://github.com/containernetworking/plugins.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "17f6ba7c9c16583da1cfbb60e5c41066f55477e048357fb0be322457973d0469"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b951c1f4e1e4f7b25c09a802d7e5eac98beac36c36109f37b77281a04c98959f"
  end

  keg_only "plugin binaries are not intended to be under the $PATH"

  depends_on "go" => :build
  depends_on :linux

  def install
    buildpath.glob("plugins/{meta,main,ipam}/*").each do |plugin_path|
      basename = plugin_path.basename
      next if basename.to_s == "windows"

      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/basename), plugin_path
    end
  end

  test do
    # Inspect supported CNI spec versions.
    ENV["CNI_COMMAND"] = "VERSION"
    output = JSON.parse shell_output("#{opt_bin}/bridge")
    assert_includes output["supportedVersions"], "1.1.0"
  end
end