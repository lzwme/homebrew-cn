cask "tidelift" do
  arch arm: "_arm"
  os macos: "darwin", linux: "linux"

  version "1.16.47"
  sha256 arm:          "70afb99df7fb1185dcc590cec7ebb7461e57300d18350f812e256341110708ec",
         intel:        "b2495f284b211171486cca71d0a5a3c89afa6f4d775d851665c303e65a639c0c",
         arm64_linux:  "32ccc2c0c57f83cb2727e4aa9f5fce3e6760a0600e955bda53974a70e95943de",
         x86_64_linux: "2773111b69bedb7951346d93958faebfd707c4f40d53953df24ee8d1c009b5c0"

  url "https://download.tidelift.com/cli/#{version}/#{os}#{arch}/tidelift"
  name "Tidelift CLI"
  desc "Tool to interact with the Tidelift system"
  homepage "https://tidelift.com/cli"

  livecheck do
    url "https://download.tidelift.com/cli/index.html"
    regex(%r{href=.*?/cli/(\d+(?:\.\d+)+)/#{os}#{arch}/tidelift}i)
  end

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  binary "tidelift"

  postflight do
    set_permissions "#{staged_path}/tidelift", "+x"
  end

  # No zap stanza required
end