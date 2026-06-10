class Container < Formula
  desc "Create and run Linux containers using lightweight virtual machines"
  homepage "https://apple.github.io/container/documentation/"
  url "https://ghfast.top/https://github.com/apple/container/archive/refs/tags/1.0.0.tar.gz"
  sha256 "9f5379d400d23b6f296b7bae8f71f982dfdc1d52bf072ac81318472a734d21f7"
  license "Apache-2.0"
  head "https://github.com/apple/container.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90c8c729df08ff62c39c11a06c64fc9e966fc5db37a5048f1313d83a8be5d5f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4ad56a2548b02a20824284c768c24d4debfe8c6406debb53ef3461afb4bad54"
  end

  depends_on xcode: ["26.0", :build]
  depends_on arch: :arm64
  depends_on macos: :sequoia

  def install
    if build.head?
      ENV["GIT_COMMIT"] = Utils.git_head
    else
      ENV["RELEASE_VERSION"] = version
    end

    system "swift", "build", "--disable-sandbox", "--configuration", "release"

    release_dir = buildpath/".build/release"

    bin.install release_dir/"container"
    bin.install release_dir/"container-apiserver"
    libexec.install "scripts/ensure-container-stopped.sh"

    # Container requires binaries and plugins to be signed with specific entitlements
    codesign "--identifier=com.apple.container.cli", bin/"container"
    codesign "--identifier=com.apple.container.apiserver", bin/"container-apiserver"

    {
      "container-core-images"   => "CoreImages",
      "container-network-vmnet" => "NetworkVMNet",
      "container-runtime-linux" => "RuntimeLinux",
    }.each do |bin_name, source|
      (libexec/"container-plugins/#{bin_name}/bin").install release_dir/bin_name
      (libexec/"container-plugins/#{bin_name}").install "Sources/Plugins/#{source}/config.toml"

      entitlement_args = []
      entitlement_args << "--entitlements=signing/#{bin_name}.entitlements" if bin_name != "container-core-images"

      codesign "--prefix=com.apple.container.", *entitlement_args,
libexec/"container-plugins/#{bin_name}/bin/#{bin_name}"
    end

    generate_completions_from_executable bin/"container", "--generate-completion-script"
  end

  def codesign(*args)
    system "/usr/bin/codesign", "-f", "-s", "-", *args
  end

  # container APIs aren't guaranteed to be backward compatible,
  # so we stop the system service to ensure no components are out of sync.
  # Ref: https://github.com/apple/container/issues/551#issuecomment-3246928923
  def post_install
    system libexec/"ensure-container-stopped.sh", "-a"
  end

  service do
    run [opt_bin/"container", "system", "start"]
    keep_alive true
    working_dir var
    log_path var/"log/container.log"
    error_log_path var/"log/container.log"
  end

  test do
    # Cannot fully test, as it needs to write outside testpath
    assert_match version.to_s, shell_output("#{bin}/container --version")

    assert_match(/Error: (?:interrupted: ")?internalError: "failed to list containers"/,
                 shell_output("#{bin}/container list 2>&1", 1))
  end
end