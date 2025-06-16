cask "font-bravura" do
  version "1.392"
  sha256 "42d18929af4cbdd13784a51c509175d4458010332d238310b4d4cd962e2bc1db"

  url "https:github.comsteinbergmediabravuraarchiverefstagsbravura-#{version}.tar.gz"
  name "Bravura"
  homepage "https:github.comsteinbergmediabravura"

  no_autobump! because: :requires_manual_review

  # Upstream may mark a release that is described as the current release on the first-party
  # page as a "pre-release" on GitHub, so we have to check the first-party page.
  livecheck do
    url "https:www.smufl.orgfonts"
    regex(%r{href=.*?bravurareleasestagbravura[._-]v?(\d+(?:\.\d+)+)"}i)
  end

  font "bravura-bravura-#{version}redistotfBravura.otf"
  font "bravura-bravura-#{version}redistotfBravuraText.otf"

  # No zap stanza required
end