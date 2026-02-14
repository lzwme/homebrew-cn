class FlowControl < Formula
  desc "Programmer's text editor"
  homepage "https://flow-control.dev/"
  # version is used to build by `git describe --always --tags`
  url "https://github.com/neurocyte/flow.git",
      tag:      "v0.7.0",
      revision: "e044d1111ea9b88558aa2d81aa1da3379080e119"
  license "MIT"
  head "https://github.com/neurocyte/flow.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa81ddefee77ddaaa0b70d7ae3277441900450e421db5c22e69b4893e2f4b9be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28a6312d3a464b69dd116e2d16171edd470d4cea02949236452ecbb80ef9784d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f28fd4c01a8fcf8b5c588408f2df414154e0111a80b214f17b193081f56a43d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cb988189249d62a91d6a5085582db59bbd2e59a20b22ee9a5dcb782cbcd5143"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c37efffee4631af70f9f6d9a9d0c38da4fa4e4b540df04f76bd17f924ebb35b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f11b31c52eb6fcbb807bbfb5fb6332227eae27575ed1a1763c2ae661bca9e67"
  end

  depends_on "zig" => :build

  def install
    # Avoid an error when the git repository is detached from HEAD
    inreplace "build.zig",
              /const describe_base_commit_ = try (.*);/,
              "const describe_base_commit_ = \\1 catch \"\";"

    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else Hardware.oldest_cpu
    end

    # Do not use `std_zig_args` or `--release=` flag here
    # as after using it all targets are installed into directories with
    # names like `<os>-<arch>-release` instead of `bin`
    args = %W[
      --prefix #{prefix}
      -Doptimize=ReleaseFast
      --summary all
    ]
    args << "-Dcpu=#{cpu}" if build.bottle?
    args << "-fno-rosetta" if OS.mac? && Hardware::CPU.intel?

    system "zig", "build", *args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flow --version")
    assert_match "Flow Control: a programmer's text editor", shell_output("#{bin}/flow --help")

    # flow-control is a tui application
    system bin/"flow", "--list-languages"
  end
end