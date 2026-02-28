cask "akuity" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"

  version "0.28.1-0.20260227070342-c11678d8fd34"
  sha256 arm:          "adf784f52c3265ef80534f34e801b4677a774d9131e2aa5e017adb6fec8d2123",
         intel:        "973ec1cfd8747c46d20dbc5fb2fc8c7420e4646b324e66840d028619498c6095",
         arm64_linux:  "ca6054fb0c45bb77d98f1ec3a8170f4a20c8d907e9db5bbb56ce49c38aa6bc32",
         x86_64_linux: "5b55cae48be91bc16b5f7a1621b58bd4a90c4dcd3100d62bc0676738a2ef344e"

  url "https://dl.akuity.io/akuity-cli/v#{version}/#{os}/#{arch}/akuity"
  name "Akuity"
  desc "Management tool for the Akuity Platform"
  homepage "https://akuity.io/"

  livecheck do
    url "https://dl.akuity.io/akuity-cli/stable.txt"
    regex(/v?(\d+(?:\.\d+)+(?:[_-]\d+(?:\.\d+)*)?(?:[_-]\h+)?)/i)
  end

  binary "akuity"

  zap trash: "~/.config/akuity"
end