class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://ghproxy.com/https://github.com/lima-vm/lima/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "1c477cb0f7bfd18d8f9755103401d2efae599ab6b327f8b73bd35031a2fd5ebe"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e8f947078c9ca24d3507a4c67a739557149157ce38797b0acb75ee4652d0219"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6ade7cdb94fff032da7834f9c15e5f73d23ccd6cb019de8b9dd010b4d279ea8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25ff5a968c228e812871bf2ad41d1e23fe01429cf35100f35c45a3395e32d012"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b31de46fd8c3ad3212e5007c875b6e84bc4ec424af41947246336b97a1d7289"
    sha256 cellar: :any_skip_relocation, ventura:        "af87fb5d44b5c39d72385f0df8346c9a2ef2e784fa9f70442e67aaa4b8c3585b"
    sha256 cellar: :any_skip_relocation, monterey:       "a26b4e1d730911f2df9a5616be0205ae273291bc65d06dcaa7a9e8ca0ab871f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bbc174341360febc1e847ca47fc6c16fb6c9fd29a25568b75b9352efdc0265e"
  end

  depends_on "go" => :build
  depends_on "qemu"

  def install
    if build.head?
      system "make"
    else
      # VERSION has to be explicitly specified when building from tar.gz, as it does not contain git tags
      system "make", "VERSION=#{version}"
    end

    bin.install Dir["_output/bin/*"]
    share.install Dir["_output/share/*"]

    # Install shell completions
    generate_completions_from_executable(bin/"limactl", "completion", base_name: "limactl")
  end

  test do
    info = JSON.parse shell_output("#{bin}/limactl info")
    # Verify that the VM drivers are compiled in
    assert_includes info["vmTypes"], "qemu"
    assert_includes info["vmTypes"], "vz" if MacOS.version >= :ventura
    # Verify that the template files are installed
    template_names = info["templates"].map { |x| x["name"] }
    assert_includes template_names, "default"
  end
end